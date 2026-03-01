using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SappingVine : Ability
    {
        public SappingVine()
        {
            Name = "Sapping Vine";
            FlavorText = "Lash the enemy with thorned vines that drain their vitality.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
            LifeStealPercent = 0.5f;
        }
    }
}
