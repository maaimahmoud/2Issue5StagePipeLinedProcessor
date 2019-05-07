LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.constants.ALL;

-- 
--   ↓
-- F D E M W    ==> pip1decode, [no data hazards]: first instruction
-- F D E M W    ==> pip2decode, [no data hazards]: if there is a dependance, it will be detected  during previous fetch cycle
--   F D E M W  ==> pip1fetch, may occur hazard due to instruction in pip2decode or pip1decode
--   F D E M W  ==> pip2fetch, may occur hazard due to instruction in pip1fetch, pip2decode or pip1decode

-- stall in all load use cases
--  * pip1fetch src or dst = dst of pip2decode or pip1decode
--          ○ pip1fetchsrc = pip2decodedst and pip2decodeLoad => |
--                                                               | => isLoadUse() => pip1DuePip2decode
--          ○ pip1fetchdst = pip2decodedst and pip2decodeLoad => |

--          ○ pip1fetchsrc = pip1decodedst and pip1decodeLoad => |
--                                                               | => isLoadUse() => pip1DuePip1decode
--          ○ pip1fetchdst = pip1decodedst and pip1decodeLoad => |
--          • pip1fetchLoad = pip1DuePip2decode OR pip1DuePip1decode

--  * pip2fetch src or dst = dst of pip1fetch, pip2decode or pip1decode
--          ○ pip2fetchsrc = pip1fetchdst and pip1fetchLoad =>   |
--                                                               | => isLoadUse() => pip2DuePip1fetch
--          ○ pip2fetchdst = pip1fetchdst and pip1fetchLoad =>   |

--          ○ pip2fetchsrc = pip2decodedst and pip2decodeLoad => |
--                                                               | => isLoadUse() => pip2DuePip2decode
--          ○ pip2fetchdst = pip2decodedst and pip2decodeLoad => |

--          ○ pip2fetchsrc = pip1decodedst and pip1decodeLoad => |
--                                                               | => isLoadUse() => pip2DuePip1decode
--          ○ pip2fetchdst = pip1decodedst and pip1decodeLoad => |

--          • pip2fetchLoad = pip2DuePip1fetch OR pip2DuePip2decode OR pip2DuePip1decode
-- ◘ stall = pip1fetchLoad OR pip2fetchLoad
ENTITY HazardDetectionUnit IS
    Generic(
        g_opcodeSize: integer := 5;
        g_regSize: integer := 3 -- src and dst size
    );
    Port(
        pip1FetchOp, pip1DecodeOp, pip2FetchOp, pip2DecodeOp: IN STD_LOGIC_VECTOR(g_opcodeSize - 1 DOWNTO 0);
        pip1FetchSrc, pip1DecodeSrc, pip2FetchSrc, pip2DecodeSrc: IN STD_LOGIC_VECTOR(g_regSize - 1 DOWNTO 0);
        pip1FetchDst, pip1DecodeDst, pip2FetchDst, pip2DecodeDst: IN STD_LOGIC_VECTOR(g_regSize - 1 DOWNTO 0);
        ---------------------------------------------
        stall: OUT STD_LOGIC
    );
END ENTITY HazardDetectionUnit;

ARCHITECTURE HazardDetectionUnitArch of HazardDetectionUnit is 
pure function f_isLoadUse (
    lastOpcode: IN STD_LOGIC_VECTOR(g_opcodeSize - 1 DOWNTO 0);
    lastDst: IN STD_LOGIC_VECTOR(g_regSize - 1 DOWNTO 0);
    newInstructionSrc: IN STD_LOGIC_VECTOR(g_regSize - 1 DOWNTO 0);
    newInstructionDst: IN STD_LOGIC_VECTOR(g_regSize - 1 DOWNTO 0);
    newInstructionOp: IN STD_LOGIC_VECTOR(g_opcodeSize - 1 DOWNTO 0)
    )
    return STD_LOGIC is
    variable newInstructionMode: STD_LOGIC_VECTOR(opModeSize - 1 DOWNTO 0);
    variable isInstructionLoad: BOOLEAN;
    variable isDataDependant: BOOLEAN;
    variable isLoad: BOOLEAN;
    variable result: STD_LOGIC;
begin
    newInstructionMode := newInstructionOp(g_opcodeSize - 1 DOWNTO g_opcodeSize - opModeSize);
    isInstructionLoad := lastOpcode = opPOP OR lastOpcode = opLDD;
    isDataDependant := 
        (
            (newInstructionMode = twoOperand OR newInstructionOp = opLDD OR newInstructionOp = opSTD) AND
            lastDst = newInstructionSrc
        )
        OR
        (
            newInstructionOp /= opNOP AND newInstructionOp /= opSETC AND newInstructionOp /= opCLRC AND
            newInstructionOp /= opIN AND newInstructionOp /= opMOV AND newInstructionOp /= opPOP AND
            newInstructionOp /= opLDD AND newInstructionOp /= opRET AND newInstructionOp /= opRTI AND
            lastDst = newInstructionDst
        );
    isLoad := isDataDependant AND isInstructionLoad;
    result := '1' when isLoad else '0';
    return result;
end;

SIGNAL pip1DuePip2decode, pip1DuePip1decode, pip1fetchLoad, pip2DuePip1fetch, pip2DuePip2decode, pip2DuePip1decode, pip2fetchLoad: STD_LOGIC;

BEGIN
    pip1DuePip2decode <= f_isLoadUse(pip2DecodeOp, pip2DecodeDst, pip1FetchSrc, pip1FetchDst, pip1FetchOp);
    pip1DuePip1decode <= f_isLoadUse(pip1DecodeOp, pip1DecodeDst, pip1FetchSrc, pip1FetchDst, pip1FetchOp);
    pip1fetchLoad <= pip1DuePip2decode OR pip1DuePip1decode;

    pip2DuePip1fetch <= f_isLoadUse(pip1FetchOp, pip1FetchDst, pip2FetchSrc, pip2FetchDst, pip2FetchOp);
    pip2DuePip2decode <= f_isLoadUse(pip2DecodeOp, pip2DecodeDst, pip2FetchSrc, pip2FetchDst, pip2FetchOp);
    pip2DuePip1decode <= f_isLoadUse(pip1DecodeOp, pip1DecodeDst, pip2FetchSrc, pip2FetchDst, pip2FetchOp);
    pip2fetchLoad <= pip2DuePip1fetch OR pip2DuePip2decode OR pip2DuePip1decode;

    stall <= pip1fetchLoad OR pip2fetchLoad;
END HazardDetectionUnitArch; -- HazardDetectionUnitArch