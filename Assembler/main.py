from assembler import Assembler
from pcsplitter import PCSplitter 
from msadapter import MSAdapter
import sys
if __name__ == "__main__":
    fileName = sys.argv[1] if len(sys.argv) >= 2 else 'program'
    piplinedProcessorAsm = Assembler()
    mcCode = piplinedProcessorAsm.assembleFromFile(fileName)
    
    mcCode = PCSplitter(mcCode).split()

    # write the machine code
    mcFile = open(f'{fileName}.mc', 'w')
    mcFile.write(mcCode)

    # adapt the code to work with model sim ram importing
    MSAdapter().adaptToFile(mcCode, fileName)