{ buildEnv, workbench, rsp-session }:
buildEnv {
  name = "posit-workbench";
  paths = [
    workbench
    rsp-session
  ];
}
