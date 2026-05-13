{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Runtimes
    codex
    pkgs.unstable.bun
    cargo

    # Version control
    gh
    github-desktop
	sourcegit
    codeberg-cli
	cloneit
	git-xet
	git-machete
	git-branchless
	gfold
	cargo-machete

    # Editors & IDEs
    pkgs.unstable.opencode
    pkgs.unstable.fresh-editor
    pkgs.unstable.claude-code
	pkgs.unstable.crush
	pkgs.unstable.opencode-desktop
	pkgs.unstable.pi-coding-agent
	pkgs.unstable.code
	pkgs.unstable.zed-editor
	pkgs.unstable.lapce

    # Development tools
    love
    pkgs.unstable.uv
    playwright
    playwright-mcp
    pkgs.unstable.claude-monitor
	pkgs.unstable.claude-code-router
	pkgs.unstable.rtk
	pkgs.unstable.spider
	ast-grep
	vectorcode
	seagoat
	just

	# LLM Servers
	pkgs.unstable.mistral-rs
	pkgs.unstable.koboldcpp
	pkgs.unstable.ollama-cpu
	pkgs.unstable.llama-swap
	pkgs.unstable.llmserve
  ];
}
