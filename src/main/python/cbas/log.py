import click

VERBOSE = False


class CMDLineExit(Exception):
    pass


def verbose(message):
    if VERBOSE:
        click.echo(message)


def info(message):
    click.echo(message)

