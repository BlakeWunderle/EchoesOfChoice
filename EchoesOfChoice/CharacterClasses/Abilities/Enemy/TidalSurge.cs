using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class TidalSurge : Ability
    {
        public TidalSurge()
        {
            Name = "Tidal Surge";
            FlavorText = "A relentless wall of water crashes forward.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
