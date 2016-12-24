all:open-flash-chart.swf

open-flash-chart.swf: main.as
	mxmlc main.as -warnings -compiler.verbose-stacktraces -compiler.use-resource-bundle-metadata -compiler.as3 -compiler.show-actionscript-warnings -compiler.show-binding-warnings -compiler.show-unused-type-selector-warnings -compiler.strict -use-network -static-link-runtime-shared-libraries -compiler.warn-deprecated-event-handler-error -compiler.warn-deprecated-function-error -compiler.warn-deprecated-property-error -o open-flash-chart.swf

clean:
	rm -rf open-flash-chart.swf
