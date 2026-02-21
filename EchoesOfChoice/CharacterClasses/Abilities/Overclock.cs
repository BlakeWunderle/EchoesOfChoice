using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Overclock : Ability
    {
        public Overclock()
        {
            Name = "Overclock";
            FlavorText = "Push cybernetic systems beyond their limits. Increases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
