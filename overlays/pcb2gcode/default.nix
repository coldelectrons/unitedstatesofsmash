{ channels, ... }:

final: prev: { 
  plusultra = (prev.plusultra or { }) // {
    pcb2gcode = prev.pcb2gcode.overrideAttrs( oldAttrs: {
      version = "git";
      src = prev.lib.fetchFromGitHub {
        owner = "pcb2gcode";
        repo = "pcb2gcode";
        rev = "8c084afd00c6653dfa9cbf24a1dbeeb24f592aa9";
        hash = "sha256-Qk+2UDigyKp7qaQ4zOViylkBDEVykE35CoUGYEL7HqY=";
      };
    });
  };
}
