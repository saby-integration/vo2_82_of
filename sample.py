import v8unpack
import os


def build(folder):
    v8unpack.build(r'{0}\src'.format(folder), r'{0}\bin\Sbis1C.epf'.format(folder), version="802", index="index.json")


def unpack(folder):
    v8unpack.extract(r'{0}\bin\Sbis1C.epf'.format(folder), r'{0}\src'.format(folder), index="index.json")


if __name__ == '__main__':
    folder = os.getcwd()
    unpack(folder)
