# Environment

# Baisc Compliping & Exec
1. javac $srcfile
compling a source file at current directory, you can get a *.class located corresponding directory.

2. javac -d $topdir $srcfile
generate class under $topdir with intermediate directory layer with package pattern.

3. java $packagedir/$intermediatedir/.../*.class
execute a class generate from some *.java files.

# RMI
Different from RPC, you should create a object using Name.lookup("classname") first, and then call it's relative method. Without objename, you can't call it's object.

With constructed appropriate parameters, you can call a RPC. Server has the responsibility to validate the request.

RPC is only a programming model, some rpc framework together with data serialization model has been provided, e.g. gRpc, swift.
