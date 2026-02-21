using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Punch : Ability
    {
        public Punch()
        {
            Name = "Punch";
            FlavorText = "Just curl up your fist and hit the enemy as hard as you can";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
