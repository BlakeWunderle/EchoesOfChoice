using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Taunt : Ability
    {
        public Taunt()
        {
            Name = "Taunt";
            FlavorText = "Draw all enemy attention, forcing them to attack you.";
            ModifiedStat = StatEnum.Taunt;
            Modifier = 0;
            impactedTurns = 1;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
