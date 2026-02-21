using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class DeathTouch : Ability
    {
        public DeathTouch()
        {
            Name = "Death Touch";
            FlavorText = "A cold hand reaches out, draining the very life essence from the enemy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
