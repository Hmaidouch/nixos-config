{ config, pkgs, lib, ... }:
let
# نستخدم homeDirectory لضمان أن المسار يشير دائماً للمجلد الحقيقي القابل للتعديل
  # استبدل "mynixos/config3" بالمسار النسبي من الـ Home
  dotfilesDir = "./mynixos";
in
{

}
