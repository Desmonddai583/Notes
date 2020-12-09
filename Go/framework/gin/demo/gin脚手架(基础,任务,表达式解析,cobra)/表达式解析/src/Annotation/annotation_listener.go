// Code generated from E:/video/2020/ginfast/pro/Annotation\Annotation.g4 by ANTLR 4.8. DO NOT EDIT.

package Annotation // Annotation
import "github.com/antlr/antlr4/runtime/Go/antlr"

// AnnotationListener is a complete listener for a parse tree produced by AnnotationParser.
type AnnotationListener interface {
	antlr.ParseTreeListener

	// EnterStart is called when entering the start production.
	EnterStart(c *StartContext)

	// EnterAnnotationWithArgs is called when entering the AnnotationWithArgs production.
	EnterAnnotationWithArgs(c *AnnotationWithArgsContext)

	// EnterAnnotationWithoutArgs is called when entering the AnnotationWithoutArgs production.
	EnterAnnotationWithoutArgs(c *AnnotationWithoutArgsContext)

	// EnterArgs is called when entering the Args production.
	EnterArgs(c *ArgsContext)

	// ExitStart is called when exiting the start production.
	ExitStart(c *StartContext)

	// ExitAnnotationWithArgs is called when exiting the AnnotationWithArgs production.
	ExitAnnotationWithArgs(c *AnnotationWithArgsContext)

	// ExitAnnotationWithoutArgs is called when exiting the AnnotationWithoutArgs production.
	ExitAnnotationWithoutArgs(c *AnnotationWithoutArgsContext)

	// ExitArgs is called when exiting the Args production.
	ExitArgs(c *ArgsContext)
}
