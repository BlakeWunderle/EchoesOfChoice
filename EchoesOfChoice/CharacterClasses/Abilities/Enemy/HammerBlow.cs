using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class HammerBlow : Ability
    {
        public HammerBlow()
        {
            Name = "Hammer Blow";
            FlavorText = "A crushing strike from an iron fist.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
