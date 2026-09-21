void main (List<String> args){
  if(args.isNotEmpty){
    print("Hello ${args[0]}");
  }else{
    print("Hello World");
  }
}