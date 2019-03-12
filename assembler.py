#!/usr/bin/python3

import sys
import struct
import pathlib
from collections import defaultdict


class Assembler:

    def __init__(self, code):
        self.data_labels = {}
        self.label_values = {}
        self.forward_labels = defaultdict(list)
        self.used = set()
        self.code = []
        self.data = []
        self.data_offset = 1
        self.code_offset = 0
        for i, line in enumerate(code):
            try:
                self.process(line, True)
            except Exception as e:
                print('ERROR, line {}: {}'.format(i + 1, e), file=sys.stderr)
                sys.exit(1)
        self.code_offset = 1 + len(self.data)
        self.code = []
        self.data = []
        for i, line in enumerate(code):
            try:
                self.process(line, False)
            except Exception as e:
                print('ERROR, line {}: {}'.format(i + 1, e), file=sys.stderr)
                sys.exit(1)
        self.output = [self.code_offset] + self.data + self.code


    def resolve_int(self, val):
        if ' - ' in val:
            l, r = val.split(' - ')
            return self.resolve_int(l.strip()) - self.resolve_int(r.strip())
        if val.startswith('$') or val.startswith('&'):
            if val not in self.data_labels:
                raise Exception('Unknown label')
            self.used.add(val)
            if val[1:].startswith('>'):
                resolved = min(i for i in self.forward_labels[val[1:]] if i[0] > len(self.code))
                return (resolved[1] if val.startswith('$') else resolved[2]) + self.data_offset
            else:
                return self.data_labels[val] + self.data_offset
        if val == '@':
            return self.code_offset + len(self.code)
        if val.startswith('@'):
            if val not in self.label_values:
                raise Exception('Unknown label')
            self.used.add(val)
            return self.label_values[val] + self.code_offset
        return int(val, 0)


    def process(self, line, dry_run):
        if '#' in line:
            line = line.split('#')[0].strip()
        if not line:
            return
        if line.startswith('.'):
            type, label, data = line.split(maxsplit=2)
            self.data_labels['$' + label] = len(self.data)
            noptr = False
            type = type[1:]
            if type.startswith('!'):
                type = type[1:]
                noptr = True
            if type == 'int':
                if dry_run:
                    num = 0
                else:
                    num = self.resolve_int(data)
                self.data.append(num)
            elif type == 'str':
                line = data.replace('\\n', '\n').replace('\\\\', '\\')
                self.data.extend(map(ord, line))
                self.data.append(0)
            elif type == 'buf':
                self.data += [0] * self.resolve_int(data)
            else:
                raise Exception('Unknown datatype')
            if not noptr:
                self.data_labels['&' + label] = len(self.data)
                self.data.append(self.data_labels['$' + label] + self.data_offset)
                if label.startswith('>') and dry_run:
                    self.forward_labels[label].append((len(self.code), self.data_labels['$' + label], self.data_labels['&' + label]))
            elif label.startswith('>'):
                raise Exception('Forward label must have a pointer to it')
            return
        if line.startswith('@'):
            self.label_values[line] = len(self.code)
            return
        if line.startswith('S'):
            _, *args = line.split()
            if len(args) != 3:
                raise Exception('Invalid number of arguments')
            for arg in args:
                if dry_run:
                    self.code.append(0)
                else:
                    self.code.append(self.resolve_int(arg))
            return
        raise Exception('Unknown command')

    def as_bytes(self):
        s = struct.Struct('i')
        return b''.join(map(s.pack, self.output))


def main():
    if len(sys.argv) > 1:
        try:
            with open(sys.argv[1]) as f:
                code = f.read()
        except OSError:
            print('Unable to read file', file=sys.stderr)
            sys.exit(1)
    else:
        code = sys.stdin.read()

    code = [l.strip() for l in code.splitlines()]

    asm = Assembler(code)
    exe_name = str(pathlib.PosixPath(sys.argv[1]).with_suffix('.img'))
    with open(exe_name, 'wb') as f:
        f.write(asm.as_bytes())

    for l in list(asm.data_labels) + list(asm.label_values):
        if l not in asm.used and '&' + l[1:] not in asm.used:
            print('Unused label:', l)


if __name__ == '__main__':
    main()
