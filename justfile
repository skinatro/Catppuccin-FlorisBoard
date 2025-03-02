set export

_default:
  @just --list

version := `jq '.meta.version' src/extension.json | tr -d '"'`

# Remove the './dist' directory
clean:
  rm -rfv ./dist

# Minify JSON files and put source files into "./dist"
build: clean
  whiskers florisboard.tera
  mkdir -p dist/stylesheets
  cat src/extension.json | jq -c > dist/extension.json
  for file in `ls src/stylesheets`; do \
      cat src/stylesheets/$file | jq -c > dist/stylesheets/$file; \
  done

# Zip "./dist" into the "./flex" format
zip: build
  rm -v catppuccin-{{version}}.flex || true
  cd dist && zip -r ../catppuccin-{{version}}.flex .
