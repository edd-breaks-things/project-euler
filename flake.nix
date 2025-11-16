{
  description = "Project Euler Haskell solutions with LaTeX documentation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowBroken = true;
        };
        
        haskellPackages = pkgs.haskellPackages;
        
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "project-euler";
          version = "0.1.0";
          src = ./.;
          
          buildInputs = with pkgs; [
            haskellPackages.ghc
            haskellPackages.cabal-install
          ];
          
          buildPhase = ''
            cabal build
          '';
          
          installPhase = ''
            mkdir -p $out/bin
            cp dist-newstyle/build/*/ghc-*/project-euler-*/x/project-euler/build/project-euler/project-euler $out/bin/project-euler
          '';
        };
        
        apps.default = flake-utils.lib.mkApp {
          drv = pkgs.writeScriptBin "run-project-euler" ''
            #!${pkgs.bash}/bin/bash
            ${pkgs.cabal-install}/bin/cabal run
          '';
        };
        
        apps.generate-pdfs = flake-utils.lib.mkApp {
          drv = pkgs.writeScriptBin "generate-pdfs" ''
            #!${pkgs.bash}/bin/bash
            
            # Create pdf directory if it doesn't exist
            mkdir -p pdf
            
            # Find all .lhs files in app directory
            echo "Generating PDFs for all problems..."
            
            latest_pdf=""
            for lhs_file in app/Problem*.lhs; do
                if [ -f "$lhs_file" ]; then
                    # Extract filename without path and extension
                    filename=$(basename "$lhs_file" .lhs)
                    
                    echo "Converting $filename.lhs to PDF..."
                    
                    # Generate PDF using pandoc
                    ${pkgs.pandoc}/bin/pandoc "$lhs_file" \
                        -o "pdf/''${filename}.pdf" \
                        --pdf-engine=${pkgs.texlive.combined.scheme-full}/bin/pdflatex \
                        --highlight-style=tango \
                        -V geometry:margin=1in \
                        -V fontsize=11pt \
                        -V documentclass=article \
                        2>/dev/null
                    
                    if [ $? -eq 0 ]; then
                        echo "  ✓ Generated pdf/''${filename}.pdf"
                        latest_pdf="pdf/''${filename}.pdf"
                    else
                        echo "  ✗ Failed to generate pdf/''${filename}.pdf"
                    fi
                fi
            done
            
            echo ""
            echo "PDF generation complete!"
            echo "PDFs are available in the 'pdf' directory"
            
            # Open the last generated PDF
            if [ -n "$latest_pdf" ]; then
                echo "Opening $latest_pdf..."
                open "$latest_pdf"
            fi
          '';
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Haskell
            haskellPackages.ghc
            haskellPackages.cabal-install
            haskellPackages.haskell-language-server
            haskellPackages.hlint
            haskellPackages.ormolu
            
            # Document processing
            pandoc
            texlive.combined.scheme-full
            
            # Other useful tools
            git
          ];
          
          shellHook = ''
            echo "Project Euler Haskell environment"
            echo "GHC version: $(ghc --version)"
            echo "Pandoc available for .lhs to PDF conversion"
            echo "Usage: pandoc Problem0000.lhs -o Problem0000.pdf"
          '';
        };
      });
}