



class PCSplitter:
    def __init__(self, mc):
        self.mc = mc

    def split(self):
        org1, resetAddress, org2, interruptAddress, remainCode = self.mc.split('\n', 4)
        return '\n'.join((org1, self._toTwoLines(resetAddress), org2, self._toTwoLines(interruptAddress), remainCode))

    def _toTwoLines(self, line):
        l1, l2 = line, ''.zfill(16)
        if (len(line) > 16):
            l2 = line[:16]
            l1 = line[16:]
        return l1 + '\n' + l2