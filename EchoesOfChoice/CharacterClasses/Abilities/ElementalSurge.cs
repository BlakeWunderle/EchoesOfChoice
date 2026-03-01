using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ElementalSurge : Ability
    {
        public ElementalSurge()
        {
            Name = "Elemental Surge";
            FlavorText = "Channel raw elemental energy into a devastating blast.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
