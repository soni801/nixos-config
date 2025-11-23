{ ... }:

{
  programs.git = {
    enable = true;
    config = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      merge.conflictStyle = "zdiff3";
      delta = {
        navigate = true;
	      line-numbers = true;
	      hyperlinks = true;
      };
    };
  };
}
