#!/usr/bin/python3
import sys
import struct

int_struct = struct.Struct('i')

def to_int(data):
    return int_struct.unpack(data)[0]

def main():
    if len(sys.argv) > 1:
        try:
            with open(sys.argv[1], 'rb') as f:
                code = f.read()
        except OSError:
            print('Unable to read file', file=sys.stderr)
            sys.exit(1)
    else:
        print('Filename required', file=sys.stderr)
        sys.exit(1)
    code_ptr = to_int(code[:4])
    for i in range(4, code_ptr * 4, 4):
        data = code[i:i + 4]
        print('.!int i{} {}'.format(i // 4, to_int(data)))
    print()

    def pretty(i):
        if 0 < i < code_ptr:
            return '$i' + str(i)
        return i

    for i in range(code_ptr * 4, len(code), 12):
        print('S {} {} {}'.format(pretty(to_int(code[i:i + 4])),
                                  pretty(to_int(code[i + 4:i + 8])),
                                  pretty(to_int(code[i + 8:i + 12]))))



if __name__ == '__main__':
    main()

