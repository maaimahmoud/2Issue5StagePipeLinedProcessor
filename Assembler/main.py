from assembler import Assembler
from msadapter import MSAdapter

if __name__ == "__main__":
    piplinedProcessorAsm = Assembler()
    mcCode = piplinedProcessorAsm.assembleFromFile('program')
    
    # write the machine code
    mcFile = open('program.mc', 'w')
    mcFile.write(mcCode)

    # adapt the code to work with model sim ram importing
    MSAdapter().adaptToFile(mcCode, 'program')