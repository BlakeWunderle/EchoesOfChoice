using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class TimeFreeze : Ability
    {
        public TimeFreeze()
        {
            Name = "Time Freeze";
            FlavorText = "Time itself grinds to a halt around the enemy.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
