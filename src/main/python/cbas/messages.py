
DEBUG = False


class CMDLineExit(Exception):
    pass


def debug(message):
    if DEBUG:
        print(message)


def info(message):
    print(message)

