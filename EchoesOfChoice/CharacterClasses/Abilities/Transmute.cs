using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Transmute : Ability
    {
        public Transmute()
        {
            Name = "Transmute";
            FlavorText = "Transform matter into something more useful.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
