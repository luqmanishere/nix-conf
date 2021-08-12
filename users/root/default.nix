{ ... }:
# recommend using `hashedPassword`
{
  users.users.root = {
    extraGroups = [ "root" ];
    password = "adminmkl";
  };
}
