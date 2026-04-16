import locale
import os
import re

from config import I18N_DIR, MD_DIR


class LocalizationApi:
    def __init__(self):
        self.locale_code = self._detect_locale()
        self._translations = self._load_po()

    def _detect_locale(self):
        sys_locale = (
            locale.getlocale()[0]
            or os.environ.get('LANG', '')
            or os.environ.get('LANGUAGE', '')
        )
        return 'fr_FR' if sys_locale.startswith('fr') else 'en_US'

    def _load_po(self):
        lang = self.locale_code[:2]
        po_file = os.path.join(I18N_DIR, f'{lang}.po')
        result = {}
        if not os.path.exists(po_file):
            return result
        with open(po_file, 'r', encoding='utf-8') as f:
            content = f.read()
        for m in re.finditer(r'msgid "([^"]+)"\s*\nmsgstr "([^"]*)"', content):
            msgid, msgstr = m.group(1), m.group(2)
            result[msgid] = msgstr if msgstr else msgid
        return result

    def tr(self, key):
        return self._translations.get(key, key)

    def markdown(self, key):
        for lc in [self.locale_code, 'en_US']:
            path = os.path.join(MD_DIR, lc, f'{key}.md')
            if os.path.exists(path):
                with open(path, 'r', encoding='utf-8') as f:
                    return f.read()
        return ''
