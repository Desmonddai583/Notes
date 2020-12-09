// Code generated from E:/video/2020/ginfast/pro/Annotation\Annotation.g4 by ANTLR 4.8. DO NOT EDIT.

package Annotation // Annotation
import (
	"fmt"
	"reflect"
	"strconv"

	"github.com/antlr/antlr4/runtime/Go/antlr"
)

// Suppress unused import errors
var _ = fmt.Printf
var _ = reflect.Copy
var _ = strconv.Itoa

var parserATN = []uint16{
	3, 24715, 42794, 33075, 47597, 16764, 15335, 30598, 22884, 3, 13, 31, 4,
	2, 9, 2, 4, 3, 9, 3, 4, 4, 9, 4, 3, 2, 3, 2, 3, 2, 3, 3, 3, 3, 3, 3, 3,
	3, 5, 3, 16, 10, 3, 3, 3, 3, 3, 3, 3, 5, 3, 21, 10, 3, 3, 4, 3, 4, 3, 4,
	7, 4, 26, 10, 4, 12, 4, 14, 4, 29, 11, 4, 3, 4, 2, 2, 5, 2, 4, 6, 2, 3,
	3, 2, 7, 9, 2, 30, 2, 8, 3, 2, 2, 2, 4, 20, 3, 2, 2, 2, 6, 22, 3, 2, 2,
	2, 8, 9, 5, 4, 3, 2, 9, 10, 7, 2, 2, 3, 10, 3, 3, 2, 2, 2, 11, 12, 7, 3,
	2, 2, 12, 13, 7, 10, 2, 2, 13, 15, 7, 4, 2, 2, 14, 16, 5, 6, 4, 2, 15,
	14, 3, 2, 2, 2, 15, 16, 3, 2, 2, 2, 16, 17, 3, 2, 2, 2, 17, 21, 7, 5, 2,
	2, 18, 19, 7, 3, 2, 2, 19, 21, 7, 10, 2, 2, 20, 11, 3, 2, 2, 2, 20, 18,
	3, 2, 2, 2, 21, 5, 3, 2, 2, 2, 22, 27, 9, 2, 2, 2, 23, 24, 7, 6, 2, 2,
	24, 26, 9, 2, 2, 2, 25, 23, 3, 2, 2, 2, 26, 29, 3, 2, 2, 2, 27, 25, 3,
	2, 2, 2, 27, 28, 3, 2, 2, 2, 28, 7, 3, 2, 2, 2, 29, 27, 3, 2, 2, 2, 5,
	15, 20, 27,
}
var deserializer = antlr.NewATNDeserializer(nil)
var deserializedATN = deserializer.DeserializeFromUInt16(parserATN)

var literalNames = []string{
	"", "'@'", "'('", "')'", "','", "", "", "", "", "'.'",
}
var symbolicNames = []string{
	"", "", "", "", "", "StringArg", "FloatArg", "IntArg", "AnnotationName",
	"Dot", "Float", "WHITESPACE",
}

var ruleNames = []string{
	"start", "annotation", "annotationArgs",
}
var decisionToDFA = make([]*antlr.DFA, len(deserializedATN.DecisionToState))

func init() {
	for index, ds := range deserializedATN.DecisionToState {
		decisionToDFA[index] = antlr.NewDFA(ds, index)
	}
}

type AnnotationParser struct {
	*antlr.BaseParser
}

func NewAnnotationParser(input antlr.TokenStream) *AnnotationParser {
	this := new(AnnotationParser)

	this.BaseParser = antlr.NewBaseParser(input)

	this.Interpreter = antlr.NewParserATNSimulator(this, deserializedATN, decisionToDFA, antlr.NewPredictionContextCache())
	this.RuleNames = ruleNames
	this.LiteralNames = literalNames
	this.SymbolicNames = symbolicNames
	this.GrammarFileName = "Annotation.g4"

	return this
}

// AnnotationParser tokens.
const (
	AnnotationParserEOF            = antlr.TokenEOF
	AnnotationParserT__0           = 1
	AnnotationParserT__1           = 2
	AnnotationParserT__2           = 3
	AnnotationParserT__3           = 4
	AnnotationParserStringArg      = 5
	AnnotationParserFloatArg       = 6
	AnnotationParserIntArg         = 7
	AnnotationParserAnnotationName = 8
	AnnotationParserDot            = 9
	AnnotationParserFloat          = 10
	AnnotationParserWHITESPACE     = 11
)

// AnnotationParser rules.
const (
	AnnotationParserRULE_start          = 0
	AnnotationParserRULE_annotation     = 1
	AnnotationParserRULE_annotationArgs = 2
)

// IStartContext is an interface to support dynamic dispatch.
type IStartContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// IsStartContext differentiates from other interfaces.
	IsStartContext()
}

type StartContext struct {
	*antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyStartContext() *StartContext {
	var p = new(StartContext)
	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(nil, -1)
	p.RuleIndex = AnnotationParserRULE_start
	return p
}

func (*StartContext) IsStartContext() {}

func NewStartContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *StartContext {
	var p = new(StartContext)

	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(parent, invokingState)

	p.parser = parser
	p.RuleIndex = AnnotationParserRULE_start

	return p
}

func (s *StartContext) GetParser() antlr.Parser { return s.parser }

func (s *StartContext) Annotation() IAnnotationContext {
	var t = s.GetTypedRuleContext(reflect.TypeOf((*IAnnotationContext)(nil)).Elem(), 0)

	if t == nil {
		return nil
	}

	return t.(IAnnotationContext)
}

func (s *StartContext) EOF() antlr.TerminalNode {
	return s.GetToken(AnnotationParserEOF, 0)
}

func (s *StartContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *StartContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *StartContext) EnterRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.EnterStart(s)
	}
}

func (s *StartContext) ExitRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.ExitStart(s)
	}
}

func (p *AnnotationParser) Start() (localctx IStartContext) {
	localctx = NewStartContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 0, AnnotationParserRULE_start)

	defer func() {
		p.ExitRule()
	}()

	defer func() {
		if err := recover(); err != nil {
			if v, ok := err.(antlr.RecognitionException); ok {
				localctx.SetException(v)
				p.GetErrorHandler().ReportError(p, v)
				p.GetErrorHandler().Recover(p, v)
			} else {
				panic(err)
			}
		}
	}()

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(6)
		p.Annotation()
	}
	{
		p.SetState(7)
		p.Match(AnnotationParserEOF)
	}

	return localctx
}

// IAnnotationContext is an interface to support dynamic dispatch.
type IAnnotationContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// IsAnnotationContext differentiates from other interfaces.
	IsAnnotationContext()
}

type AnnotationContext struct {
	*antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyAnnotationContext() *AnnotationContext {
	var p = new(AnnotationContext)
	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(nil, -1)
	p.RuleIndex = AnnotationParserRULE_annotation
	return p
}

func (*AnnotationContext) IsAnnotationContext() {}

func NewAnnotationContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *AnnotationContext {
	var p = new(AnnotationContext)

	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(parent, invokingState)

	p.parser = parser
	p.RuleIndex = AnnotationParserRULE_annotation

	return p
}

func (s *AnnotationContext) GetParser() antlr.Parser { return s.parser }

func (s *AnnotationContext) CopyFrom(ctx *AnnotationContext) {
	s.BaseParserRuleContext.CopyFrom(ctx.BaseParserRuleContext)
}

func (s *AnnotationContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *AnnotationContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

type AnnotationWithoutArgsContext struct {
	*AnnotationContext
}

func NewAnnotationWithoutArgsContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *AnnotationWithoutArgsContext {
	var p = new(AnnotationWithoutArgsContext)

	p.AnnotationContext = NewEmptyAnnotationContext()
	p.parser = parser
	p.CopyFrom(ctx.(*AnnotationContext))

	return p
}

func (s *AnnotationWithoutArgsContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *AnnotationWithoutArgsContext) AnnotationName() antlr.TerminalNode {
	return s.GetToken(AnnotationParserAnnotationName, 0)
}

func (s *AnnotationWithoutArgsContext) EnterRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.EnterAnnotationWithoutArgs(s)
	}
}

func (s *AnnotationWithoutArgsContext) ExitRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.ExitAnnotationWithoutArgs(s)
	}
}

type AnnotationWithArgsContext struct {
	*AnnotationContext
}

func NewAnnotationWithArgsContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *AnnotationWithArgsContext {
	var p = new(AnnotationWithArgsContext)

	p.AnnotationContext = NewEmptyAnnotationContext()
	p.parser = parser
	p.CopyFrom(ctx.(*AnnotationContext))

	return p
}

func (s *AnnotationWithArgsContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *AnnotationWithArgsContext) AnnotationName() antlr.TerminalNode {
	return s.GetToken(AnnotationParserAnnotationName, 0)
}

func (s *AnnotationWithArgsContext) AnnotationArgs() IAnnotationArgsContext {
	var t = s.GetTypedRuleContext(reflect.TypeOf((*IAnnotationArgsContext)(nil)).Elem(), 0)

	if t == nil {
		return nil
	}

	return t.(IAnnotationArgsContext)
}

func (s *AnnotationWithArgsContext) EnterRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.EnterAnnotationWithArgs(s)
	}
}

func (s *AnnotationWithArgsContext) ExitRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.ExitAnnotationWithArgs(s)
	}
}

func (p *AnnotationParser) Annotation() (localctx IAnnotationContext) {
	localctx = NewAnnotationContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 2, AnnotationParserRULE_annotation)
	var _la int

	defer func() {
		p.ExitRule()
	}()

	defer func() {
		if err := recover(); err != nil {
			if v, ok := err.(antlr.RecognitionException); ok {
				localctx.SetException(v)
				p.GetErrorHandler().ReportError(p, v)
				p.GetErrorHandler().Recover(p, v)
			} else {
				panic(err)
			}
		}
	}()

	p.SetState(18)
	p.GetErrorHandler().Sync(p)
	switch p.GetInterpreter().AdaptivePredict(p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		localctx = NewAnnotationWithArgsContext(p, localctx)
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(9)
			p.Match(AnnotationParserT__0)
		}
		{
			p.SetState(10)
			p.Match(AnnotationParserAnnotationName)
		}
		{
			p.SetState(11)
			p.Match(AnnotationParserT__1)
		}
		p.SetState(13)
		p.GetErrorHandler().Sync(p)
		_la = p.GetTokenStream().LA(1)

		if ((_la)&-(0x1f+1)) == 0 && ((1<<uint(_la))&((1<<AnnotationParserStringArg)|(1<<AnnotationParserFloatArg)|(1<<AnnotationParserIntArg))) != 0 {
			{
				p.SetState(12)
				p.AnnotationArgs()
			}

		}
		{
			p.SetState(15)
			p.Match(AnnotationParserT__2)
		}

	case 2:
		localctx = NewAnnotationWithoutArgsContext(p, localctx)
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(16)
			p.Match(AnnotationParserT__0)
		}
		{
			p.SetState(17)
			p.Match(AnnotationParserAnnotationName)
		}

	}

	return localctx
}

// IAnnotationArgsContext is an interface to support dynamic dispatch.
type IAnnotationArgsContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// IsAnnotationArgsContext differentiates from other interfaces.
	IsAnnotationArgsContext()
}

type AnnotationArgsContext struct {
	*antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyAnnotationArgsContext() *AnnotationArgsContext {
	var p = new(AnnotationArgsContext)
	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(nil, -1)
	p.RuleIndex = AnnotationParserRULE_annotationArgs
	return p
}

func (*AnnotationArgsContext) IsAnnotationArgsContext() {}

func NewAnnotationArgsContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *AnnotationArgsContext {
	var p = new(AnnotationArgsContext)

	p.BaseParserRuleContext = antlr.NewBaseParserRuleContext(parent, invokingState)

	p.parser = parser
	p.RuleIndex = AnnotationParserRULE_annotationArgs

	return p
}

func (s *AnnotationArgsContext) GetParser() antlr.Parser { return s.parser }

func (s *AnnotationArgsContext) CopyFrom(ctx *AnnotationArgsContext) {
	s.BaseParserRuleContext.CopyFrom(ctx.BaseParserRuleContext)
}

func (s *AnnotationArgsContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *AnnotationArgsContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

type ArgsContext struct {
	*AnnotationArgsContext
}

func NewArgsContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *ArgsContext {
	var p = new(ArgsContext)

	p.AnnotationArgsContext = NewEmptyAnnotationArgsContext()
	p.parser = parser
	p.CopyFrom(ctx.(*AnnotationArgsContext))

	return p
}

func (s *ArgsContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ArgsContext) AllFloatArg() []antlr.TerminalNode {
	return s.GetTokens(AnnotationParserFloatArg)
}

func (s *ArgsContext) FloatArg(i int) antlr.TerminalNode {
	return s.GetToken(AnnotationParserFloatArg, i)
}

func (s *ArgsContext) AllStringArg() []antlr.TerminalNode {
	return s.GetTokens(AnnotationParserStringArg)
}

func (s *ArgsContext) StringArg(i int) antlr.TerminalNode {
	return s.GetToken(AnnotationParserStringArg, i)
}

func (s *ArgsContext) AllIntArg() []antlr.TerminalNode {
	return s.GetTokens(AnnotationParserIntArg)
}

func (s *ArgsContext) IntArg(i int) antlr.TerminalNode {
	return s.GetToken(AnnotationParserIntArg, i)
}

func (s *ArgsContext) EnterRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.EnterArgs(s)
	}
}

func (s *ArgsContext) ExitRule(listener antlr.ParseTreeListener) {
	if listenerT, ok := listener.(AnnotationListener); ok {
		listenerT.ExitArgs(s)
	}
}

func (p *AnnotationParser) AnnotationArgs() (localctx IAnnotationArgsContext) {
	localctx = NewAnnotationArgsContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 4, AnnotationParserRULE_annotationArgs)
	var _la int

	defer func() {
		p.ExitRule()
	}()

	defer func() {
		if err := recover(); err != nil {
			if v, ok := err.(antlr.RecognitionException); ok {
				localctx.SetException(v)
				p.GetErrorHandler().ReportError(p, v)
				p.GetErrorHandler().Recover(p, v)
			} else {
				panic(err)
			}
		}
	}()

	localctx = NewArgsContext(p, localctx)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(20)
		_la = p.GetTokenStream().LA(1)

		if !(((_la)&-(0x1f+1)) == 0 && ((1<<uint(_la))&((1<<AnnotationParserStringArg)|(1<<AnnotationParserFloatArg)|(1<<AnnotationParserIntArg))) != 0) {
			p.GetErrorHandler().RecoverInline(p)
		} else {
			p.GetErrorHandler().ReportMatch(p)
			p.Consume()
		}
	}
	p.SetState(25)
	p.GetErrorHandler().Sync(p)
	_la = p.GetTokenStream().LA(1)

	for _la == AnnotationParserT__3 {
		{
			p.SetState(21)
			p.Match(AnnotationParserT__3)
		}
		{
			p.SetState(22)
			_la = p.GetTokenStream().LA(1)

			if !(((_la)&-(0x1f+1)) == 0 && ((1<<uint(_la))&((1<<AnnotationParserStringArg)|(1<<AnnotationParserFloatArg)|(1<<AnnotationParserIntArg))) != 0) {
				p.GetErrorHandler().RecoverInline(p)
			} else {
				p.GetErrorHandler().ReportMatch(p)
				p.Consume()
			}
		}

		p.SetState(27)
		p.GetErrorHandler().Sync(p)
		_la = p.GetTokenStream().LA(1)
	}

	return localctx
}
