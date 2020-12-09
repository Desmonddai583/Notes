// Code generated from E:/video/2020/ginfast/pro/Annotation\Annotation.g4 by ANTLR 4.8. DO NOT EDIT.

package Annotation

import (
	"fmt"
	"unicode"

	"github.com/antlr/antlr4/runtime/Go/antlr"
)

// Suppress unused import error
var _ = fmt.Printf
var _ = unicode.IsLetter

var serializedLexerAtn = []uint16{
	3, 24715, 42794, 33075, 47597, 16764, 15335, 30598, 22884, 2, 13, 90, 8,
	1, 4, 2, 9, 2, 4, 3, 9, 3, 4, 4, 9, 4, 4, 5, 9, 5, 4, 6, 9, 6, 4, 7, 9,
	7, 4, 8, 9, 8, 4, 9, 9, 9, 4, 10, 9, 10, 4, 11, 9, 11, 4, 12, 9, 12, 4,
	13, 9, 13, 3, 2, 3, 2, 3, 3, 3, 3, 3, 4, 3, 4, 3, 5, 3, 5, 3, 6, 3, 6,
	3, 7, 3, 7, 3, 7, 3, 7, 3, 7, 3, 7, 7, 7, 44, 10, 7, 12, 7, 14, 7, 47,
	11, 7, 3, 7, 3, 7, 3, 8, 5, 8, 52, 10, 8, 3, 8, 3, 8, 3, 9, 5, 9, 57, 10,
	9, 3, 9, 6, 9, 60, 10, 9, 13, 9, 14, 9, 61, 3, 10, 6, 10, 65, 10, 10, 13,
	10, 14, 10, 66, 3, 11, 3, 11, 3, 12, 6, 12, 72, 10, 12, 13, 12, 14, 12,
	73, 5, 12, 76, 10, 12, 3, 12, 3, 12, 6, 12, 80, 10, 12, 13, 12, 14, 12,
	81, 3, 13, 6, 13, 85, 10, 13, 13, 13, 14, 13, 86, 3, 13, 3, 13, 2, 2, 14,
	3, 3, 5, 4, 7, 5, 9, 6, 11, 2, 13, 7, 15, 8, 17, 9, 19, 10, 21, 11, 23,
	12, 25, 13, 3, 2, 6, 3, 2, 50, 59, 4, 2, 41, 41, 94, 94, 4, 2, 67, 92,
	99, 124, 5, 2, 11, 12, 15, 15, 34, 34, 2, 99, 2, 3, 3, 2, 2, 2, 2, 5, 3,
	2, 2, 2, 2, 7, 3, 2, 2, 2, 2, 9, 3, 2, 2, 2, 2, 13, 3, 2, 2, 2, 2, 15,
	3, 2, 2, 2, 2, 17, 3, 2, 2, 2, 2, 19, 3, 2, 2, 2, 2, 21, 3, 2, 2, 2, 2,
	23, 3, 2, 2, 2, 2, 25, 3, 2, 2, 2, 3, 27, 3, 2, 2, 2, 5, 29, 3, 2, 2, 2,
	7, 31, 3, 2, 2, 2, 9, 33, 3, 2, 2, 2, 11, 35, 3, 2, 2, 2, 13, 37, 3, 2,
	2, 2, 15, 51, 3, 2, 2, 2, 17, 56, 3, 2, 2, 2, 19, 64, 3, 2, 2, 2, 21, 68,
	3, 2, 2, 2, 23, 75, 3, 2, 2, 2, 25, 84, 3, 2, 2, 2, 27, 28, 7, 66, 2, 2,
	28, 4, 3, 2, 2, 2, 29, 30, 7, 42, 2, 2, 30, 6, 3, 2, 2, 2, 31, 32, 7, 43,
	2, 2, 32, 8, 3, 2, 2, 2, 33, 34, 7, 46, 2, 2, 34, 10, 3, 2, 2, 2, 35, 36,
	9, 2, 2, 2, 36, 12, 3, 2, 2, 2, 37, 45, 7, 41, 2, 2, 38, 39, 7, 94, 2,
	2, 39, 44, 11, 2, 2, 2, 40, 41, 7, 41, 2, 2, 41, 44, 7, 41, 2, 2, 42, 44,
	10, 3, 2, 2, 43, 38, 3, 2, 2, 2, 43, 40, 3, 2, 2, 2, 43, 42, 3, 2, 2, 2,
	44, 47, 3, 2, 2, 2, 45, 43, 3, 2, 2, 2, 45, 46, 3, 2, 2, 2, 46, 48, 3,
	2, 2, 2, 47, 45, 3, 2, 2, 2, 48, 49, 7, 41, 2, 2, 49, 14, 3, 2, 2, 2, 50,
	52, 7, 47, 2, 2, 51, 50, 3, 2, 2, 2, 51, 52, 3, 2, 2, 2, 52, 53, 3, 2,
	2, 2, 53, 54, 5, 23, 12, 2, 54, 16, 3, 2, 2, 2, 55, 57, 7, 47, 2, 2, 56,
	55, 3, 2, 2, 2, 56, 57, 3, 2, 2, 2, 57, 59, 3, 2, 2, 2, 58, 60, 5, 11,
	6, 2, 59, 58, 3, 2, 2, 2, 60, 61, 3, 2, 2, 2, 61, 59, 3, 2, 2, 2, 61, 62,
	3, 2, 2, 2, 62, 18, 3, 2, 2, 2, 63, 65, 9, 4, 2, 2, 64, 63, 3, 2, 2, 2,
	65, 66, 3, 2, 2, 2, 66, 64, 3, 2, 2, 2, 66, 67, 3, 2, 2, 2, 67, 20, 3,
	2, 2, 2, 68, 69, 7, 48, 2, 2, 69, 22, 3, 2, 2, 2, 70, 72, 5, 11, 6, 2,
	71, 70, 3, 2, 2, 2, 72, 73, 3, 2, 2, 2, 73, 71, 3, 2, 2, 2, 73, 74, 3,
	2, 2, 2, 74, 76, 3, 2, 2, 2, 75, 71, 3, 2, 2, 2, 75, 76, 3, 2, 2, 2, 76,
	77, 3, 2, 2, 2, 77, 79, 7, 48, 2, 2, 78, 80, 5, 11, 6, 2, 79, 78, 3, 2,
	2, 2, 80, 81, 3, 2, 2, 2, 81, 79, 3, 2, 2, 2, 81, 82, 3, 2, 2, 2, 82, 24,
	3, 2, 2, 2, 83, 85, 9, 5, 2, 2, 84, 83, 3, 2, 2, 2, 85, 86, 3, 2, 2, 2,
	86, 84, 3, 2, 2, 2, 86, 87, 3, 2, 2, 2, 87, 88, 3, 2, 2, 2, 88, 89, 8,
	13, 2, 2, 89, 26, 3, 2, 2, 2, 13, 2, 43, 45, 51, 56, 61, 66, 73, 75, 81,
	86, 3, 8, 2, 2,
}

var lexerDeserializer = antlr.NewATNDeserializer(nil)
var lexerAtn = lexerDeserializer.DeserializeFromUInt16(serializedLexerAtn)

var lexerChannelNames = []string{
	"DEFAULT_TOKEN_CHANNEL", "HIDDEN",
}

var lexerModeNames = []string{
	"DEFAULT_MODE",
}

var lexerLiteralNames = []string{
	"", "'@'", "'('", "')'", "','", "", "", "", "", "'.'",
}

var lexerSymbolicNames = []string{
	"", "", "", "", "", "StringArg", "FloatArg", "IntArg", "AnnotationName",
	"Dot", "Float", "WHITESPACE",
}

var lexerRuleNames = []string{
	"T__0", "T__1", "T__2", "T__3", "DIGIT", "StringArg", "FloatArg", "IntArg",
	"AnnotationName", "Dot", "Float", "WHITESPACE",
}

type AnnotationLexer struct {
	*antlr.BaseLexer
	channelNames []string
	modeNames    []string
	// TODO: EOF string
}

var lexerDecisionToDFA = make([]*antlr.DFA, len(lexerAtn.DecisionToState))

func init() {
	for index, ds := range lexerAtn.DecisionToState {
		lexerDecisionToDFA[index] = antlr.NewDFA(ds, index)
	}
}

func NewAnnotationLexer(input antlr.CharStream) *AnnotationLexer {

	l := new(AnnotationLexer)

	l.BaseLexer = antlr.NewBaseLexer(input)
	l.Interpreter = antlr.NewLexerATNSimulator(l, lexerAtn, lexerDecisionToDFA, antlr.NewPredictionContextCache())

	l.channelNames = lexerChannelNames
	l.modeNames = lexerModeNames
	l.RuleNames = lexerRuleNames
	l.LiteralNames = lexerLiteralNames
	l.SymbolicNames = lexerSymbolicNames
	l.GrammarFileName = "Annotation.g4"
	// TODO: l.EOF = antlr.TokenEOF

	return l
}

// AnnotationLexer tokens.
const (
	AnnotationLexerT__0           = 1
	AnnotationLexerT__1           = 2
	AnnotationLexerT__2           = 3
	AnnotationLexerT__3           = 4
	AnnotationLexerStringArg      = 5
	AnnotationLexerFloatArg       = 6
	AnnotationLexerIntArg         = 7
	AnnotationLexerAnnotationName = 8
	AnnotationLexerDot            = 9
	AnnotationLexerFloat          = 10
	AnnotationLexerWHITESPACE     = 11
)
