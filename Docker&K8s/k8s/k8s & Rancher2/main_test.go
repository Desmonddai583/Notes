package main

import "testing"

func Test_isAllNumber(t *testing.T) {
	tests := []struct {
		name string
		args string
		want bool
	}{
		// TODO: Add test cases.
		{"t1", "abc", false},
		{"t2", "a123", false},
		{"t3", "1_23", false},
		{"t4", "123", true},
		{"t5", "1234a", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := isAllNumber(tt.args); got != tt.want {
				t.Errorf("isAllNumber() = %v, want %v", got, tt.want)
			}
		})
	}
}
