using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Torrent : Ability
    {
        public Torrent()
        {
            Name = "Torrent";
            FlavorText = "A surging rush of water slams into the target.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
