import sys
from dbt.cli.main import cli

if __name__ == '__main__':
    # Add profiles-dir to all commands automatically to ensure local execution
    args = sys.argv[1:]
    if "--profiles-dir" not in args:
        args.extend(["--profiles-dir", "."])
    sys.exit(cli(args))
