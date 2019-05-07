from utils import Helper
selected = {}
def setMC(test=False):
    global selected
    # selected = mc_test if test else mc
    selected = mc

def getMachineCode(param):
    try:
        return Helper.strToBinary16(param)
    except ValueError:
        mc = selected.get(param)
        if(mc == None):
            raise Exception(
                f"Not valid param: {param}, can't find its machine code")
        return mc


mc = {
        # no operand instruction => always put the src and dst with zeros
        'NOP': '00000000000',
        'SETC':'00001000000',
        'CLRC':'00010000000',
        'RET': '11101000000',
        'RTI': '11110000000',

        # one operand instruction => always put the src with zeros
        'NOT': '00011000',
        'INC': '00100000',
        'DEC': '00101000',
        'OUT': '00110000',
        'IN':  '00111000',

        'PUSH':'10000000',
        'POP': '10001000',
        'LDM': '10010000',

        'JZ':   '11000000',
        'JN':   '11001000',
        'JC':   '11010000',
        'JMP':  '11011000',
        'CALL': '11100000',

        # two operand instruction
        'MOV': '01000',
        'ADD': '01001',
        'SUB': '01010',
        'AND': '01011',
        'OR':  '01100',
        'SHL': '01101',
        'SHR': '01110',

        'LDD': '10011',
        'STD': '10100',


        # Rsrc or Rdst
        'R0': '000',
        'R1': '001',
        'R2': '010',
        'R3': '011',
        'R4': '100',
        'R5': '101',
        'R6': '110',
        'R7': '111',

        # if the operand is empty return empty string
        '': '',
}

mc_test = {
        'NOP': '$NOP',
        'SETC': '$SETC',
        'CLRC': '$CLRC',

        'INC': '$INC',
        'DEC': '$DEC',
        'NOT': '$NOT',

        'OUT': '$OUT'	,
        'IN': '$IN'	,


        'MOV': '$MOV',
        'ADD': '$ADD',
        'SUB': '$SUB',
        'AND': '$AND',
        'OR': '$OR'	,
        'SHL': '$SHL',
        'SHR': '$SHR',


        'PUSH': '$PUSH',
        'POP': '$POP' 	,

        'LDM': '$LDM'	,

        'LDD': '$LDD' 	,
        'STD': '$STD' 	,


        'JZ': '$JZ',
        'JN': '$JN',
        'JC': '$JC',

        'JMP': '$JMP',

        'CALL': '$CALL',

        'RET': '$RET'	,
        'RTI': '$RTI'	,


        'R0': '$R0'	,
        'R1': '$R1'	,
        'R2': '$R2'	,
        'R3': '$R3'	,
        'R4': '$R4'	,
        'R5': '$R5'	,
        'R6': '$R6'	,
        'R7': '$R7',

        '': '',
}

setMC()