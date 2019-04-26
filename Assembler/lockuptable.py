# def getMachineCode(param):
#     mc = {
#         'NOP': '0000000010000000',
#         'SETC': '0000000010000000',
#         'CLRC': '0000000010000000',

#         'INC': '0000001010',
#         'DEC': '0000001011',

#         'OUT': '0000001010',
#         'IN': '0000001011',


#         'MOV': '0001',
#         'ADD': '0010',
#         'SUB': '0100',
#         'AND': '0110',
#         'OR': '0111',
#         'SHL': '0111',
#         'SHR': '0111',


#         'PUSH': '00001000',
#         'POP': '00001001',

#         'LDM': '00001010',

#         'LDD': '00001011',
#         'STD': '00001100',


#         'JZ': '00001101',
#         'JN': '00001110',
#         'JC': '0000000001000000',

#         'JMP': '0000000011000000',

#         'CALL': '0000000100000000',

#         'RET': '000',
#         'RTI': '001',


#         'R0': '000',
#         'R1': '001',
#         'R2': '010',
#         'R3': '011',
#         'R4': '100',
#         'R5': '101',
#         'R6': '110',
#         'R7': '111',

#     }.get(param)
#     if(not mc):
#         raise Exception(
#             f"Not valid param: {param}, can't find its machine code")
#     return mc


def getMachineCode(param):
    mc = {
        'NOP': '$NOP',
        'SETC': '$SETC',
        'CLRC': '$CLRC',

        'INC': '$INC',
        'DEC': '$DEC',

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
    }.get(param)
    if(not mc):
        raise Exception(f"Not valid param: {param}, can't find its machine code")
    return mc