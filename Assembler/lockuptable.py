from utils import Helper
selected = {}
def setMC(test=False):
    global selected
    selected = mc_test if test else mc

def getMachineCode(param):
    if param.isdigit():
        return Helper.strToBinary16(param)
    mc = selected.get(param)
    if(mc == None):
        raise Exception(
            f"Not valid param: {param}, can't find its machine code")
    return mc


mc = {
        'NOP': '0000000010000000',
        'SETC': '0000000010000000',
        'CLRC': '0000000010000000',

        'INC': '00100',
        'DEC': '00101',
        'NOT': '00101', # TODO: edit its machine code

        'OUT': '00110',
        'IN': '00111',


        'MOV': '01000',
        'ADD': '01001',
        'SUB': '01010',
        'AND': '01011',
        'OR': '01100',
        'SHL': '01101',
        'SHR': '01110',


        'PUSH': '10000',
        'POP': '10001',

        'LDM': '10010',

        'LDD': '10011',
        'STD': '10100',


        'JZ': '11000',
        'JN': '11001',
        'JC': '11010',

        'JMP': '11011',

        'CALL': '0000000100000000',

        'RET': '000',
        'RTI': '001',


        'R0': '000',
        'R1': '001',
        'R2': '010',
        'R3': '011',
        'R4': '100',
        'R5': '101',
        'R6': '110',
        'R7': '111',

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