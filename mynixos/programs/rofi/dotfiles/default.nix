{ config, lib, ... }:
let
# نستخدم homeDirectory لضمان أن المسار يشير دائماً للمجلد الحقيقي القابل للتعديل
  # استبدل "mynixos/config3" بالمسار النسبي من الـ Home
  dotfilesDir = "${config.home.homeDirectory}/mynixos/config3";
in
{ 
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/programs/rofi";
}
