from configobj import ConfigObj
from validate import Validator
import misc

CONFIG_SPEC_PATH = 'config_spec_and_defaults.conf'

_config = None


def parse_crawler_config(config_path='crawler.conf',
                         options={}):
    global _config

    # 1. get configs
    _config = ConfigObj(infile=misc.execution_path(config_path),
                        configspec=misc.execution_path(CONFIG_SPEC_PATH))

    # 2. apply defaults
    vdt = Validator()
    _config.validate(vdt)

    # 3. overwrite with command line arguments if any
    crawlers = _config['crawlers']
    for plugin in crawlers:
        if 'avoid_setns' in options:
            crawlers[plugin]['avoid_setns'] = options['avoid_setns']


def get_config():
    global _config

    if not _config:
        parse_crawler_config()

    return _config
