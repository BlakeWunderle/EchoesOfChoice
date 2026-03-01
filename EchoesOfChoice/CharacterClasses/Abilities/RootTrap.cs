using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class RootTrap : Ability
    {
        public RootTrap()
        {
            Name = "Root Trap";
            FlavorText = "Entangle a foe in grasping roots, slowing their movement.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
