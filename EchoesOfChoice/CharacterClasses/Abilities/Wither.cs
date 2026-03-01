using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Wither : Ability
    {
        public Wither()
        {
            Name = "Wither";
            FlavorText = "Drain the vitality from a foe, weakening their defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
