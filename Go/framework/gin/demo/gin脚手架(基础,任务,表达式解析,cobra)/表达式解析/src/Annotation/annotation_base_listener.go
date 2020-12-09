// Code generated from E:/video/2020/ginfast/pro/Annotation\Annotation.g4 by ANTLR 4.8. DO NOT EDIT.

package Annotation // Annotation
import "github.com/antlr/antlr4/runtime/Go/antlr"

// BaseAnnotationListener is a complete listener for a parse tree produced by AnnotationParser.
type BaseAnnotationListener struct{}

var _ AnnotationListener = &BaseAnnotationListener{}

// VisitTerminal is called when a terminal node is visited.
func (s *BaseAnnotationListener) VisitTerminal(node antlr.TerminalNode) {}

// VisitErrorNode is called when an error node is visited.
func (s *BaseAnnotationListener) VisitErrorNode(node antlr.ErrorNode) {}

// EnterEveryRule is called when any rule is entered.
func (s *BaseAnnotationListener) EnterEveryRule(ctx antlr.ParserRuleContext) {}

// ExitEveryRule is called when any rule is exited.
func (s *BaseAnnotationListener) ExitEveryRule(ctx antlr.ParserRuleContext) {}

// EnterStart is called when production start is entered.
func (s *BaseAnnotationListener) EnterStart(ctx *StartContext) {}

// ExitStart is called when production start is exited.
func (s *BaseAnnotationListener) ExitStart(ctx *StartContext) {}

// EnterAnnotationWithArgs is called when production AnnotationWithArgs is entered.
func (s *BaseAnnotationListener) EnterAnnotationWithArgs(ctx *AnnotationWithArgsContext) {}

// ExitAnnotationWithArgs is called when production AnnotationWithArgs is exited.
func (s *BaseAnnotationListener) ExitAnnotationWithArgs(ctx *AnnotationWithArgsContext) {}

// EnterAnnotationWithoutArgs is called when production AnnotationWithoutArgs is entered.
func (s *BaseAnnotationListener) EnterAnnotationWithoutArgs(ctx *AnnotationWithoutArgsContext) {}

// ExitAnnotationWithoutArgs is called when production AnnotationWithoutArgs is exited.
func (s *BaseAnnotationListener) ExitAnnotationWithoutArgs(ctx *AnnotationWithoutArgsContext) {}

// EnterArgs is called when production Args is entered.
func (s *BaseAnnotationListener) EnterArgs(ctx *ArgsContext) {}

// ExitArgs is called when production Args is exited.
func (s *BaseAnnotationListener) ExitArgs(ctx *ArgsContext) {}
