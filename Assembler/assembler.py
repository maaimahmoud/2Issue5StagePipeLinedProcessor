from lockuptable import getMachineCode as mc
from utils import Helper
import lockuptable
lockuptable.setMC(test=True) # TODO: remove this line after testing

class InstructionsLooper:
    def __init__(self, parserFunction):
        self.util = Helper()
        self.parser = parserFunction
        pass

    def fromFile(self, fileName):
        parsed = ""
        codeLines = open(fileName, 'r').readlines()
        for instruction in codeLines:
            instruction = self.util.cleanInstruction(instruction)
            if not instruction:
                continue
            parsed += self.parser(instruction) + '\n'
        return parsed


class Assembler:
    mapper = {
        # special parsing
        "SHL": '_SHParser',
        "SHR": '_SHParser',
        "LDM": '_LDMParser',

        # assembler instruction
        ".ORG": "_ORGParser",

        # support for many operations by converting them to our processor instruction set
        "SET": "_SETParser"
    }

    def __init__(self):
        pass

    def assembleFromFile(self, fileName):
        self.looper = InstructionsLooper(self._parseInstruction)
        return self.looper.fromFile(fileName + ".asm")

    def _parseInstruction(self, instruction):
        instruction = str(instruction)
        operation, operand1, operand2 = Helper.splitInstruction(instruction)
        parser = self._defaultParser
        if operation in self.mapper:
            parser = getattr(self, self.mapper.get(operation))
        print(instruction, "=>", operation, operand1,
              operand2, "will be parsed with", parser.__name__)
        assembled = parser(operation, operand1, operand2)
        return assembled

    def _defaultParser(self, operation, operand1, operand2):
        return f"{mc(operation)}{mc(operand1)}{mc(operand2)}"

    def _LDMParser(self, operation, operand1, operand2):
        instr2 = Helper.strToBinary16(operand2)
        return f"{mc(operation)}{mc(operand1)}\n{instr2}"

    def _SHParser(self, operation, operand1, operand2):
        print(operand1, operand2)
        immediateBin = Helper.strToBinary16(operand2, fill=5)
        return f"{mc(operation)}{immediateBin[0]}00{mc(operand1)}"

    def _ORGParser(self, operation, operand1, operand2):
        return operation + operand1  # return it like 'ORG100'

    def _SETParser(self, operation, operand1, operand2):
        print("[Warning]: the operation set is not supported for current processor, it will be converted to move")
        operation = "MOV"
        operand2 = '1'
        return self._defaultParser(operation, operand1, operand2)  # return it like 'ORG100'


h = Helper()
