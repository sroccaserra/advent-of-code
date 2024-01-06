module Day19 where

import Control.Applicative
import Data.Maybe
import Text.ParserCombinators.ReadP
import Debug.Trace
import Data.List

main = interact $ show . partTwo . lines

partTwo xs = length $ catMaybes $ map (parseMaybe rule_0) values
  where values = filter ((`elem` "ab") . head) $ filter (not . null) xs

parseMaybe :: ReadP a -> String -> Maybe a
parseMaybe parser input =
  case reverse $ readP_to_S parser input of
       [] -> Nothing
       ((result, _):_) -> Just result

exRule_0 = exRule_4 *> exRule_1 *> exRule_5 *> eof
exRule_1 = exRule_2 *> exRule_3 <|> exRule_3 *> exRule_2
exRule_2 = exRule_4 *> exRule_4 <|> exRule_5 *> exRule_5
exRule_3 = exRule_4 *> exRule_5 <|> exRule_5 *> exRule_4
exRule_4 = string "a"
exRule_5 = string "b"

-- rule_8 = rule_42
rule_8 = rule_42 <|> rule_42 *> rule_8
-- rule_11 = rule_42 *> rule_31
rule_11 = rule_42 *> rule_31 <|> rule_42 *> rule_11 *> rule_31

rule_58 = rule_127 *> rule_99 <|> rule_105 *> rule_36
rule_56 = rule_71 *> rule_99 <|> rule_102 *> rule_36
rule_116 = rule_36 <|> rule_99
rule_42 = rule_19 *> rule_36 <|> rule_68 *> rule_99
rule_67 = rule_36 *> rule_71 <|> rule_99 *> rule_73
rule_117 = rule_81 *> rule_99 <|> rule_80 *> rule_36
rule_77 = rule_99 *> rule_37 <|> rule_36 *> rule_83
rule_106 = rule_27 *> rule_99 <|> rule_32 *> rule_36
rule_73 = rule_36 *> rule_99 <|> rule_99 *> rule_99
rule_126 = rule_15 *> rule_36 <|> rule_73 *> rule_99
rule_133 = rule_99 *> rule_99 <|> rule_36 *> rule_116
rule_92 = rule_99 *> rule_51 <|> rule_36 *> rule_14
rule_61 = rule_99 *> rule_21 <|> rule_36 *> rule_6
rule_6 = rule_54 *> rule_116
rule_33 = rule_36 *> rule_103 <|> rule_99 *> rule_9
rule_131 = rule_54 *> rule_99 <|> rule_15 *> rule_36
rule_81 = rule_36 *> rule_38 <|> rule_99 *> rule_78
rule_93 = rule_99 *> rule_100 <|> rule_36 *> rule_87
rule_1 = rule_113 *> rule_99 <|> rule_129 *> rule_36
rule_36 = string "b"
rule_70 = rule_99 *> rule_130 <|> rule_36 *> rule_122
rule_76 = rule_99 *> rule_4 <|> rule_36 *> rule_44
rule_79 = rule_65 *> rule_99 <|> rule_48 *> rule_36
rule_99 = string "a"
rule_108 = rule_118 *> rule_99 <|> rule_96 *> rule_36
rule_15 = rule_36 *> rule_36
rule_2 = rule_99 *> rule_102 <|> rule_36 *> rule_27
rule_103 = rule_109 *> rule_99 <|> rule_136 *> rule_36
rule_9 = rule_23 *> rule_99 <|> rule_63 *> rule_36
rule_12 = rule_15 *> rule_99 <|> rule_123 *> rule_36
rule_137 = rule_36 *> rule_54 <|> rule_99 *> rule_20
rule_13 = rule_36 *> rule_30 <|> rule_99 *> rule_70
rule_7 = rule_99 *> rule_32 <|> rule_36 *> rule_102
rule_94 = rule_18 *> rule_36 <|> rule_59 *> rule_99
rule_71 = rule_36 *> rule_99
rule_3 = rule_99 *> rule_104 <|> rule_36 *> rule_62
rule_4 = rule_72 *> rule_99 <|> rule_114 *> rule_36
rule_32 = rule_36 *> rule_36 <|> rule_99 *> rule_36
rule_21 = rule_27 *> rule_99 <|> rule_122 *> rule_36
rule_52 = rule_99 *> rule_20 <|> rule_36 *> rule_73
rule_135 = rule_99 *> rule_116 <|> rule_36 *> rule_99
rule_31 = rule_95 *> rule_99 <|> rule_89 *> rule_36
rule_24 = rule_99 *> rule_107 <|> rule_36 *> rule_125
rule_19 = rule_36 *> rule_77 <|> rule_99 *> rule_28
rule_112 = rule_15 *> rule_36 <|> rule_15 *> rule_99
rule_89 = rule_99 *> rule_50 <|> rule_36 *> rule_111
rule_23 = rule_99 *> rule_34 <|> rule_36 *> rule_73
rule_69 = rule_36 *> rule_54 <|> rule_99 *> rule_73
rule_85 = rule_12 *> rule_99 <|> rule_25 *> rule_36
rule_53 = rule_36 *> rule_54
rule_95 = rule_36 *> rule_76 <|> rule_99 *> rule_117
rule_124 = rule_106 *> rule_99 <|> rule_22 *> rule_36
rule_10 = rule_102 *> rule_99 <|> rule_122 *> rule_36
rule_107 = rule_99 *> rule_133 <|> rule_36 *> rule_34
rule_129 = rule_54 *> rule_99 <|> rule_71 *> rule_36
rule_16 = rule_36 *> rule_130 <|> rule_99 *> rule_27
rule_86 = rule_36 *> rule_122 <|> rule_99 *> rule_102
rule_45 = rule_97 *> rule_36 <|> rule_41 *> rule_99
rule_102 = rule_99 *> rule_99 <|> rule_116 *> rule_36
rule_25 = rule_32 *> rule_36 <|> rule_133 *> rule_99
rule_87 = rule_99 *> rule_52 <|> rule_36 *> rule_115
rule_119 = rule_91 *> rule_99 <|> rule_101 *> rule_36
rule_34 = rule_99 *> rule_99
rule_121 = rule_36 *> rule_91 <|> rule_99 *> rule_52
rule_29 = rule_102 *> rule_36 <|> rule_27 *> rule_99
rule_20 = rule_116 *> rule_116
rule_47 = rule_36 *> rule_36 <|> rule_99 *> rule_99
rule_49 = rule_123 *> rule_99
rule_38 = rule_99 *> rule_98 <|> rule_36 *> rule_86
rule_123 = rule_36 *> rule_36 <|> rule_36 *> rule_99
rule_48 = rule_36 *> rule_123 <|> rule_99 *> rule_54
rule_51 = rule_36 *> rule_54 <|> rule_99 *> rule_102
rule_98 = rule_73 *> rule_99 <|> rule_47 *> rule_36
rule_26 = rule_20 *> rule_99 <|> rule_34 *> rule_36
rule_68 = rule_36 *> rule_88 <|> rule_99 *> rule_108
rule_111 = rule_75 *> rule_36 <|> rule_5 *> rule_99
rule_54 = rule_99 *> rule_36 <|> rule_99 *> rule_99
rule_109 = rule_47 *> rule_36 <|> rule_20 *> rule_99
rule_0 = rule_8 *> rule_11 *> eof
rule_17 = rule_36 *> rule_57 <|> rule_99 *> rule_120
rule_66 = rule_99 *> rule_132 <|> rule_36 *> rule_35
rule_62 = rule_36 *> rule_130 <|> rule_99 *> rule_32
rule_59 = rule_36 *> rule_130 <|> rule_99 *> rule_122
rule_44 = rule_99 *> rule_60 <|> rule_36 *> rule_92
rule_122 = rule_99 *> rule_36
rule_74 = rule_126 *> rule_99 <|> rule_16 *> rule_36
rule_37 = rule_82 *> rule_99 <|> rule_85 *> rule_36
rule_65 = rule_130 *> rule_36 <|> rule_27 *> rule_99
rule_80 = rule_58 *> rule_36 <|> rule_43 *> rule_99
rule_55 = rule_99 *> rule_130 <|> rule_36 *> rule_20
rule_118 = rule_66 *> rule_36 <|> rule_3 *> rule_99
rule_5 = rule_24 *> rule_36 <|> rule_124 *> rule_99
rule_14 = rule_36 *> rule_54 <|> rule_99 *> rule_71
rule_96 = rule_40 *> rule_99 <|> rule_61 *> rule_36
rule_22 = rule_36 *> rule_34 <|> rule_99 *> rule_135
rule_97 = rule_36 *> rule_27 <|> rule_99 *> rule_20
rule_43 = rule_99 *> rule_128 <|> rule_36 *> rule_29
rule_101 = rule_73 *> rule_36 <|> rule_133 *> rule_99
rule_91 = rule_133 *> rule_36 <|> rule_54 *> rule_99
rule_114 = rule_36 *> rule_112 <|> rule_99 *> rule_52
rule_83 = rule_79 *> rule_99 <|> rule_74 *> rule_36
rule_28 = rule_134 *> rule_99 <|> rule_39 *> rule_36
rule_72 = rule_99 *> rule_26 <|> rule_36 *> rule_49
rule_78 = rule_36 *> rule_25 <|> rule_99 *> rule_90
rule_30 = rule_102 *> rule_99 <|> rule_133 *> rule_36
rule_27 = rule_99 *> rule_36 <|> rule_36 *> rule_99
rule_35 = rule_99 *> rule_27 <|> rule_36 *> rule_15
rule_84 = rule_2 *> rule_36 <|> rule_64 *> rule_99
rule_75 = rule_1 *> rule_36 <|> rule_119 *> rule_99
rule_115 = rule_130 *> rule_36 <|> rule_71 *> rule_99
rule_39 = rule_99 *> rule_84 <|> rule_36 *> rule_121
rule_40 = rule_99 *> rule_69 <|> rule_36 *> rule_110
rule_63 = rule_36 *> rule_32
rule_88 = rule_17 *> rule_99 <|> rule_93 *> rule_36
rule_120 = rule_53 *> rule_99 <|> rule_55 *> rule_36
rule_105 = rule_99 *> rule_133 <|> rule_36 *> rule_123
rule_127 = rule_36 *> rule_123 <|> rule_99 *> rule_47
rule_134 = rule_99 *> rule_46 <|> rule_36 *> rule_45
rule_50 = rule_36 *> rule_33 <|> rule_99 *> rule_138
rule_82 = rule_131 *> rule_99 <|> rule_59 *> rule_36
rule_104 = rule_122 *> rule_99 <|> rule_27 *> rule_36
rule_113 = rule_34 *> rule_36 <|> rule_123 *> rule_99
rule_125 = rule_99 *> rule_123 <|> rule_36 *> rule_54
rule_64 = rule_54 *> rule_36
rule_46 = rule_36 *> rule_10 <|> rule_99 *> rule_107
rule_130 = rule_99 *> rule_36 <|> rule_36 *> rule_116
rule_18 = rule_36 *> rule_54 <|> rule_99 *> rule_34
rule_110 = rule_99 *> rule_34 <|> rule_36 *> rule_27
rule_136 = rule_99 *> rule_15 <|> rule_36 *> rule_73
rule_132 = rule_122 *> rule_36 <|> rule_133 *> rule_99
rule_128 = rule_15 *> rule_99 <|> rule_102 *> rule_36
rule_57 = rule_36 *> rule_56 <|> rule_99 *> rule_67
rule_100 = rule_99 *> rule_63 <|> rule_36 *> rule_137
rule_60 = rule_7 *> rule_99 <|> rule_63 *> rule_36
rule_90 = rule_36 *> rule_122 <|> rule_99 *> rule_133
rule_41 = rule_34 *> rule_36
rule_138 = rule_99 *> rule_94 <|> rule_36 *> rule_13
