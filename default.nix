{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  llvmPackages,
  clang,
  ocl-icd,
}:

let
  mnn = fetchFromGitHub {
    owner = "alibaba";
    repo = "MNN";
    tag = "2.9.6";
    hash = "sha256-jsCdiFW8oIlKISo/+qrMDy8/RHblrgaQdSuQhoiOd8M=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "newbee-ocr-cli";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "zibo-chen";
    repo = "newbee-ocr-cli";
    tag = "v${version}";
    hash = "sha256-I4fT36ATshg6Zy+a8m+hypqknNf5x4cLiU/k/7GfHsA=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
    llvmPackages.libclang
  ];

  buildInputs = [
    clang
    ocl-icd
  ];

  cargoBuildFlags = [
    "--features"
    "embed-rec-chinese,embed-det-v5,embed-det-v5-fp16"
  ];

  cargoCheckFlags = [
    "--features"
    "embed-rec-chinese,embed-det-v5,embed-det-v5-fp16"
  ];

  env.MNN_SOURCE_DIR = mnn;

  meta = with lib; {
    description = "OCR CLI based on rust-paddle-ocr";
    homepage = "https://github.com/zibo-chen/newbee-ocr-cli";
    license = licenses.asl20;
    mainProgram = "nbocr";
    platforms = platforms.linux;
  };
}
