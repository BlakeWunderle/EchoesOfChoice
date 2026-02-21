using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Topple : Ability
    {
        public Topple()
        {
            Name = "Topple";
            FlavorText = "A low sweeping kick that sends the enemy crashing to the ground.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
