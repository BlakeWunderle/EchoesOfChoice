using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Overdrive : Ability
    {
        public Overdrive()
        {
            Name = "Overdrive";
            FlavorText = "Push systems beyond their limits. Increases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
