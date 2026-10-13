; extends

((CharData) @constant
  (#lua-match? @constant "^%$%{[^}]+%}$")
  (#set! priority 110))
