from pybuilder.core import use_plugin, init, Author
from pybuilder.vcs import VCSRevision

use_plugin("python.core")
use_plugin("python.unittest")
use_plugin("python.install_dependencies")
use_plugin("python.flake8")
use_plugin("python.coverage")
use_plugin("python.distutils")
use_plugin("python.cram")


name = "cbas"
default_task = "publish"
version = VCSRevision().get_git_revision_count()
summary = 'Command line interface to the c-bastion'
authors = [
    Author('Sebastian Spoerer', "sebastian.spoerer@immobilienscout24.de"),
    Author('Valentin Haenel', "valentin.haenel@immobilienscout24.de"),
]
url = 'https://github.com/ImmobilienScout24/cbas'


@init
def set_properties(project):
    project.depends_on('click')
    project.depends_on('keyring')
    project.depends_on('secretstorage')
    project.depends_on('yamlreader')
    project.build_depends_on('requests_mock')
    project.build_depends_on('mock')
