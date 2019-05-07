class Helper:
    def __init__(self):
        pass

    def cleanInstruction(self, instr):
        instr = instr.strip() # remove any spaces and \n in the end of the line
        instr = instr.upper()
        commentIndex = instr.find('#')
        if(commentIndex != -1):
            instr = instr[0:commentIndex]
        return str(instr.strip())

    @classmethod
    def splitInstruction(cls, instruction):
        operation, operand1, operand2 = instruction, '', ''
        commaIndex = instruction.find(',')
        spaceIndex = instruction.find(' ')
        if(spaceIndex != -1 ):
            operation = instruction[0:spaceIndex].strip()
            if(commaIndex != -1):
                operand1 = instruction[spaceIndex + 1:commaIndex].strip()
                operand2 = instruction[commaIndex + 1:].strip()
                return operation, operand1, operand2
            operand1 = instruction[spaceIndex + 1:].strip()
        return operation, operand1, operand2

    @classmethod
    def strToBinary16(cls, numStr, fill=16):
        # // numStr = str(numStr)
        # // binary = bin(numStr)[2:]
        # // sixtyFill = binary.zfill(fill)
        # // return sixtyFill'
        # fill -= 1
        num = int(numStr, 16)
        binary = format(num if num >= 0 else (1 << fill) + num, "0{}b".format(fill))
        return str(binary)
        if(int(numStr) >= 0):
            return str(bin(int(str(numStr))))[2:].zfill(fill)
        else:
            return cls.twos_comp(str(bin(int(str(numStr)))[3:]), fill)

    @classmethod
    def twos_comp(cls, bitString, fill):
        """compute the 2's complement of int value val"""
        val = int(bitString, 2)
        bits = len(bitString)
        if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
            val = val - (1 << bits)       # compute negative value
        binaryStr = str(bin(val))
        print (binaryStr)
        binaryStr = binaryStr.replace('-0b', '1')
        while(len(binaryStr) < fill):
            binaryStr = '1' + binaryStr

        return binaryStr