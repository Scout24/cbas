import click

DEBUG = False


class CMDLineExit(Exception):
    pass


def debug(message):
    if DEBUG:
        click.echo(message)


def info(message):
    click.echo(message)

